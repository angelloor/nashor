import { Company } from 'app/modules/core/company/company.types';

export interface ProcessType {
  id_process_type: string;
  company: Company;
  name_process_type: string;
  description_process_type: string;
  acronym_process_type: string;
  sequential_process_type: number;
  deleted_process_type: boolean;
}
