-- Query to extract data from XML document using dynamic XML namespace and root element or a default namespace and root element.
declare
    rf_cur                   sys_refcursor;
    cl_sql                   clob;
begin
    --Get data from notification message for acknowledgement
    cl_sql := q'[
                select
                        xml.message_id,
                        xml.receiver_id,
                        xml.sender_id,
                    from
                        document d,
                        xmltable (
                            xmlnamespaces ( default
                ]'
              || dbms_assert.enquote_literal( '<xml_namespace_uri>' )
              || '),'
              || dbms_assert.enquote_literal( apex_string.format('/%s/BusinessDocumentHeader', '<xml_root_element>'))
              || q'[
                    passing d.document
                            columns
                                message_id         varchar2(100) path 'MessageID',
                                receiver_id        varchar2(100) path 'Destination/Receiver/ReceiverID',
                                sender_id          varchar2(100) path 'Source/SenderID',
                                creationtimestamp  varchar2(100) path 'CreationTimestamp'
                        ) xml
                    where d.doc_id = :p_doc_id
                  ]';

    -- open cursor with bind variable
    open rf_cur for cl_sql
      using pi_doc_id;

    -- fetch results
    fetch rf_cur into
      s_xml_message_id,
      s_xml_receiver_id,
      s_xml_sender_id;
    close rf_cur;
end;
/