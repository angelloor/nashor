import { Attached } from '../../../attached/attached.types';
import { Level } from '../../../level/level.types';
import { Official } from '../../../official/official.types';
import { Process } from '../../../process/process.types';
import { Task } from '../../task.types';

export interface ProcessAttached {
  id_process_attached: string;
  official: Official;
  process: Process;
  task: Task;
  level: Level;
  attached: Attached;
  file_name: string;
  length_mb: string;
  extension: string;
  server_path: string;
  alfresco_path: string;
  upload_date: string;
  deleted_process_attached: boolean;
}
