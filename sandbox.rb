DecoError.connection.exec_update(<<-EOQ, 'SQL', [[nil, '1'])
UPDATE  deco_errors
SET     folder_id = $1
WHERE   id = #{deco_error['id']}
EOQ