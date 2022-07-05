import { Company } from 'app/modules/core/company/company.types';
import { ProcessType } from '../process-type/process-type.types';

export interface Flow {
  id_flow: string;
  company: Company;
  process_type: ProcessType;
  name_flow: string;
  description_flow: string;
  deleted_flow: boolean;
}
