import { control } from '../../../control/control.data';
import { level } from '../../../level/level.data';
import { official } from '../../../official/official.data';
import { process } from '../../../process/process.data';
import { task } from '../../../task/task.data';
import { ProcessControl } from './process-control.types';

export const processControls: ProcessControl[] = [];
export const processControl: ProcessControl = {
  id_process_control: ' ',
  official: official,
  process: process,
  task: task,
  level: level,
  control: control,
  value_process_control: ' ',
  last_change_process_control: ' ',
  deleted_process_control: false,
};
