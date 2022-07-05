import { company } from 'app/modules/core/company/company.data';
import { ProcessType } from './process-type.types';

export const processTypes: ProcessType[] = [];
export const processType: ProcessType = {
  id_process_type: ' ',
  company: company,
  name_process_type: ' ',
  description_process_type: ' ',
  acronym_process_type: ' ',
  sequential_process_type: 1,
  deleted_process_type: false,
};
