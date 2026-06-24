#!/usr/bin/env node
const fs = require('fs');
const { execSync } = require('child_process');

// ============================================================================
// AUTOMATED LIQUIBASE MERGE DRIVER
// ============================================================================
//
// DESCRIPTION:
//   Automates Git merges/rebases for 'dist/releases/next/release.changelog.xml'.
//   It locks your Develop branch sequence in place and cleanly appends incoming
//   feature lines to the bottom of the list. Non-trailing conflicts are bypassed for manual fix.
//
// PREREQUISITES / REQUIREMENTS:
//   1. Node.js installed on your machine (run `node -v` to verify).
//   2. The script must be saved as '.dbtools/liquibase-merge.js' from the repository root.
//   3. (Optional) On Unix environments (macOS/Linux), make the file executable:
//      Run: chmod +x .dbtools/liquibase-merge.js
//
// SYSTEM INSTALLATION STEPS (Execute these commands in your project terminal):
//
//   Step 1: Map the driver name to the script path location
//     git config merge.liquibase-smart-union.driver "node ./.dbtools/liquibase-merge.js %O %A %B"
//
//   Step 2: Force Git to respect this driver during local rebases
//     git config rebase.merge driver
//
//   Step 3: Create or append the target file rule to your .gitattributes file:
//     • For Git Bash / Linux / macOS (Universal):
//       echo "dist/releases/next/release.changelog.xml merge=liquibase-smart-union" >> .gitattributes
//
//     • For Windows Command Prompt (cmd):
//       echo dist/releases/next/release.changelog.xml merge=liquibase-smart-union >> .gitattributes
//
//     • For Windows PowerShell:
//       Add-Content -Path .gitattributes -Value "dist/releases/next/release.changelog.xml merge=liquibase-smart-union"
//
// ============================================================================

// ============================================================================
// 1. INPUT ASSIGNMENTS & INITIAL VALIDATION
// Git passes 3 path arguments to our script when a conflict is found:
// %O = The Common Ancestor (before anyone split off or made changes)
// %A = Current Branch / Develop (Our baseline source of truth)
// %B = Other Branch / Feature (The incoming branch trying to merge in)
// ============================================================================
const ancestorPath = process.argv[2];
const currentPath = process.argv[3];
const otherPath = process.argv[4];

if (!ancestorPath || !currentPath || !otherPath) {
  console.error("Error: Missing file arguments. Ensure your git attributes/config maps %O %A %B");
  process.exit(1);
}

// Helper utility: Reads a file, splits it into lines, cleans up empty spaces,
// and extracts ONLY the lines that look like a Liquibase <include> tag.
function getIncludeLines(filePath) {
  const content = fs.readFileSync(filePath, 'utf8');
  return content
    .split(/\r?\n/)
    .map(line => line.trim())
    .filter(line => line.startsWith('<include'));
}

// Take an immediate snapshot of the Develop branch file content in memory.
// If the conflict happens to be a complex structure change (not an append conflict),
// we will restore this clean snapshot and let Git handle the conflict manually.
const backupCurrentContent = fs.readFileSync(currentPath);

try {
  // ============================================================================
  // 2. ATTEMPT NATIVE GIT MERGE FIRST (IN-BETWEEN CHANGES)
  // We run Git's standard "merge-file" tool behind the scenes in quiet mode (-q).
  // If a developer made changes "in-between" lines (like editing or reordering historical lines),
  // Git's native intelligence is best suited to handle it.
  // ============================================================================
  execSync(`git merge-file -q "${currentPath}" "${ancestorPath}" "${otherPath}"`);

  // If execSync runs without throwing an exception, it means Git resolved it cleanly.
  // We exit gracefully with a 0 status code and let Git finish the merge.
  process.exit(0);
} catch (error) {
  // ============================================================================
  // 3. FALLBACK ACTIVATION: CONFLICT DETECTED
  // If we reach this catch block, the standard merge failed (meaning developers
  // simultaneously appended different trailing lines). We must run our custom logic.
  // ============================================================================

  // First, instantly wipe Git's partial merge mess and restore our clean, original Develop backup.
  fs.writeFileSync(currentPath, backupCurrentContent);

  // Read the files in their clean states and extract all the <include> tags.
  const currentLines = fs.readFileSync(currentPath, 'utf8').split(/\r?\n/);
  const currentIncludes = getIncludeLines(currentPath);
  const otherIncludes = getIncludeLines(otherPath);

  // Turn Develop's includes into a fast-lookup "Set" (a collection of unique items).
  const currentSet = new Set(currentIncludes);

  // Filter out any lines from the feature branch that already exist in develop.
  // This isolates ONLY the truly new, uniquely added feature tags.
  const newIncludes = otherIncludes.filter(line => !currentSet.has(line));

  // ============================================================================
  // 4. FIND THE DEPLOYMENT ANCHOR POINT
  // We need to find exactly where Develop's last active include tag resides.
  // We scan the current lines from the bottom of the file going upwards.
  // ============================================================================
  let lastIncludeIndex = -1;
  let previousMergeCount = 0;

  for (let i = currentLines.length - 1; i >= 0; i--) {
    const lineTrimmed = currentLines[i].trim();

    // Find the anchor line index
    if (lastIncludeIndex === -1 && lineTrimmed.startsWith('<include')) {
      lastIncludeIndex = i;
    }

    // Scan backwards to see how many merge comments already exist in the file history
    if (lineTrimmed.includes('Added by liquibase-merge.js')) {
      previousMergeCount++;
    }
  }

  // Determine the next sequence number (e.g., if 0 exist, this is sequence 1)
  const nextSequenceNumber = previousMergeCount + 1;

  // ============================================================================
  // 5. SAFETY NET: UNTOUCHED MANIFEST MANIPULATION
  // If the file does not contain any include tags (e.g., someone deleted them, or
  // the conflict happened in the top metadata schema headers), our script steps aside.
  // ============================================================================
  if (lastIncludeIndex === -1) {
    try {
      // Re-run the standard merge-file without quiet mode so Git generates
      // its normal conflict markers (<<<<<<< HEAD) for the developer to fix manually.
      execSync(`git merge-file "${currentPath}" "${ancestorPath}" "${otherPath}"`);
    } catch (e) { /* Expected exit code due to deliberate conflict injection */ }
    process.exit(1); // Exit with a failure code to halt Git and trigger manual merge layout.
  }

  // ============================================================================
  // 6. ASSEMBLE CHRONOLOGICAL APPEND-ONLY RECONSTRUCTION
  // We stitch the file back together line-by-line using precise array slicing.
  // ============================================================================

  // Phase A: Take Develop exactly as it is from line 0 up to and including the anchor point.
  // This guarantees that Develop's current sequence, order, and history are completely frozen.
  const mergedLines = currentLines.slice(0, lastIncludeIndex + 1);

  // Phase B: Force-append the uniquely isolated incoming features.
  // We postfix each line with a sequence comment to preserve Liquibase XML visual formatting.
  if (newIncludes.length > 0) {
    newIncludes.forEach(line => {
      // Inline formatting combines the line content, and the sequence comment trailing at the end
      mergedLines.push(`${line}    <!-- ${nextSequenceNumber}. Added by liquibase-merge.js -->`);
    });
  }

  // Phase C: Append the closing structural tag to properly terminate the XML document structure.
  mergedLines.push('</databaseChangeLog>');

  // ============================================================================
  // 7. COMMIT RESOLUTION TO DISK
  // We overwrite the target file with our combined array using standard newlines.
  // ============================================================================
  fs.writeFileSync(currentPath, mergedLines.join('\n'), 'utf8');

  // Exit with 0 to inform Git that the file conflict has been completely and successfully resolved.
  process.exit(0);
}
