select dev.ddl_config('business');

update dev.ddl_config dc set haved_handler_attribute = 'name_area' where dc.table_name = 'area';
update dev.ddl_config dc set haved_handler_attribute = 'name_position' where dc.table_name = 'position';
update dev.ddl_config dc set haved_handler_attribute = 'name_level_profile' where dc.table_name = 'level_profile';
update dev.ddl_config dc set haved_handler_attribute = 'name_documentation_profile' where dc.table_name = 'documentation_profile';
update dev.ddl_config dc set haved_handler_attribute = 'name_attached' where dc.table_name = 'attached';
update dev.ddl_config dc set haved_handler_attribute = 'number_process' where dc.table_name = 'process';
update dev.ddl_config dc set haved_handler_attribute = 'name_flow' where dc.table_name = 'flow';
update dev.ddl_config dc set haved_handler_attribute = 'name_template' where dc.table_name = 'template';
update dev.ddl_config dc set haved_handler_attribute = 'form_name_control' where dc.table_name = 'control';
update dev.ddl_config dc set haved_handler_attribute = 'name_item' where dc.table_name = 'item';
update dev.ddl_config dc set haved_handler_attribute = 'name_item_category' where dc.table_name = 'item_category';
update dev.ddl_config dc set haved_handler_attribute = 'name_level_status' where dc.table_name = 'level_status';
update dev.ddl_config dc set haved_handler_attribute = 'name_level' where dc.table_name = 'level';

select dev.ddl_create_sequences('business');
select dev.ddl_create_view('business');
select dev.ddl_create_crud_all('business');

select dev.dml_reset_sequences('business');
select dev.dml_truncate_all('business');

-- ONLY TABLES RESET
-- SELECT setval('business.serial_process', 1);
-- SELECT setval('business.serial_task', 1);

-- TRUNCATE TABLE business.process CASCADE;
-- TRUNCATE TABLE business.task CASCADE;
