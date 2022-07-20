import { Level } from 'app/modules/business/level/level.types';
import { Official } from 'app/modules/business/official/official.types';
import { Process } from 'app/modules/business/process/process.types';
import { Task } from '../../task.types';

export interface ProcessComment {
  id_process_comment: string;
  official: Official;
  process: Process;
  task: Task;
  level: Level;
  value_process_comment: string;
  date_process_comment: string;
  deleted_process_comment: boolean;
}
