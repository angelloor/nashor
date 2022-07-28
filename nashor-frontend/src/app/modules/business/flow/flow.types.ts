import { Company } from 'app/modules/core/company/company.types';

export interface Flow {
  id_flow: string;
  company: Company;
  name_flow: string;
  description_flow: string;
  acronym_flow: string;
  acronym_task: string;
  sequential_flow: number;
  deleted_flow: boolean;
}
