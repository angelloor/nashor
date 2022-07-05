import { company } from 'app/modules/core/company/company.data';
import { processType } from '../process-type/process-type.data';
import { Flow } from './flow.types';

export const flows: Flow[] = [];
export const flow: Flow = {
  id_flow: ' ',
  company: company,
  process_type: processType,
  name_flow: ' ',
  description_flow: ' ',
  deleted_flow: false,
};
