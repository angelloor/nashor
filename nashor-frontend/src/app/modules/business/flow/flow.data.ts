import { company } from 'app/modules/core/company/company.data';
import { Flow } from './flow.types';

export const flows: Flow[] = [];
export const flow: Flow = {
  id_flow: ' ',
  company: company,
  name_flow: ' ',
  description_flow: ' ',
  acronym_flow: ' ',
  acronym_task: ' ',
  sequential_flow: 1,
  deleted_flow: false,
};
