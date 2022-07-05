import { Company } from 'app/modules/core/company/company.types';

export interface LevelStatus {
  id_level_status: string;
  company: Company;
  name_level_status: string;
  description_level_status: string;
  color_level_status: string;
  deleted_level_status: boolean;
}
