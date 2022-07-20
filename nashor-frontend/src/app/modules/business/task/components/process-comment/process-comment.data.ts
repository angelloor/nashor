import { level } from 'app/modules/business/level/level.data';
import { official } from 'app/modules/business/official/official.data';
import { process } from 'app/modules/business/process/process.data';
import { task } from '../../task.data';
import { ProcessComment } from './process-comment.types';

export const processComments: ProcessComment[] = [];
export const processComment: ProcessComment = {
  id_process_comment: ' ',
  official: official,
  process: process,
  task: task,
  level: level,
  value_process_comment: ' ',
  date_process_comment: ' ',
  deleted_process_comment: false,
};
