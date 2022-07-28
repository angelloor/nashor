import { flowVersion } from '../flow/flow-version/flow-version.data';
import { official } from '../official/official.data';
import { Process } from './process.types';

export const processs: Process[] = [];
export const process: Process = {
  id_process: ' ',
  official: official,
  flow_version: flowVersion,
  number_process: ' ',
  date_process: ' ',
  generated_task: false,
  finalized_process: false,
  deleted_process: false,
};
