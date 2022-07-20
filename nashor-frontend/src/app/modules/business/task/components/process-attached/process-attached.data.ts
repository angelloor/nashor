import { attached } from '../../../attached/attached.data';
import { level } from '../../../level/level.data';
import { official } from '../../../official/official.data';
import { process } from '../../../process/process.data';
import { task } from '../../task.data';
import { ProcessAttached } from './process-attached.types';

export const processAttacheds: ProcessAttached[] = [];
export const processAttached: ProcessAttached = {
  id_process_attached: ' ',
  official: official,
  process: process,
  task: task,
  level: level,
  attached: attached,
  file_name: ' ',
  length_mb: ' ',
  extension: ' ',
  server_path: ' ',
  alfresco_path: ' ',
  upload_date: ' ',
  deleted_process_attached: false,
};
