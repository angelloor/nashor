import { level } from '../level/level.data';
import { official } from '../official/official.data';
import { process } from '../process/process.data';
import { Task } from './task.types';

export const tasks: Task[] = [];
export const task: Task = {
  id_task: ' ',
  process: process,
  official: official,
  level: level,
  number_task: ' ',
  type_status_task: 'progress',
  date_task: ' ',
  deleted_task: false,
};
