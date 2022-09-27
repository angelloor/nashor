import { pluginItemColumn } from '../plugin-item/plugin-item-column/plugin-item-column.data';
import { processItem } from '../task/components/process-item/process-item.data';
import { ColumnProcessItem } from './column-process-item.types';

export const columnProcessItems: ColumnProcessItem[] = [];
export const columnProcessItem: ColumnProcessItem = {
  id_column_process_item: ' ',
  plugin_item_column: pluginItemColumn,
  process_item: processItem,
  value_column_process_item: ' ',
  entry_date_column_process_item: ' ',
};
