import { Company } from 'app/modules/core/company/company.types';

export interface Position {
  id_position: string;
  company: Company;
  name_position: string;
  description_position: string;
  deleted_position: boolean;
}
