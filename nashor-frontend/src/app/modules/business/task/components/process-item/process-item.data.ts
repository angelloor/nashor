import { item } from '../../../item/item.data';
import { level } from '../../../level/level.data';
import { official } from '../../../official/official.data';
import { process } from '../../../process/process.data';
import { task } from '../../../task/task.data';
import { ProcessItem } from './process-item.types';

export const processItems: ProcessItem[] = [];
export const processItem: ProcessItem = {
  id_process_item: ' ',
  official: official,
  process: process,
  task: task,
  level: level,
  item: item,
};
