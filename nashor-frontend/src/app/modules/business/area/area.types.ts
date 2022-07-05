import { Company } from 'app/modules/core/company/company.types';

export interface Area {
  id_area: string;
  company: Company;
  name_area: string;
  description_area: string;
  deleted_area: boolean;
}
