import { PluginItemColumn } from '../plugin-item/plugin-item-column/plugin-item-column.types';
import { ProcessItem } from '../task/components/process-item/process-item.types';

export interface ColumnProcessItem {
  id_column_process_item: string;
  plugin_item_column: PluginItemColumn;
  process_item: ProcessItem;
  value_column_process_item: string;
  entry_date_column_process_item: string;
}
