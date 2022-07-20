import { Control } from '../../../control/control.types';
import { Level } from '../../../level/level.types';
import { Official } from '../../../official/official.types';
import { Process } from '../../../process/process.types';
import { Task } from '../../../task/task.types';

export interface ProcessControl {
  id_process_control: string;
  official: Official;
  process: Process;
  task: Task;
  level: Level;
  control: Control;
  value_process_control: string;
  last_change_process_control: string;
  deleted_process_control: boolean;
}
