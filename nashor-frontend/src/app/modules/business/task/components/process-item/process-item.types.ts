import { Item } from '../../../item/item.types';
import { Level } from '../../../level/level.types';
import { Official } from '../../../official/official.types';
import { Process } from '../../../process/process.types';
import { Task } from '../../../task/task.types';

export interface ProcessItem {
  id_process_item: string;
  official: Official;
  process: Process;
  task: Task;
  level: Level;
  item: Item;
}
