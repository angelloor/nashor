import { Company } from 'app/modules/core/company/company.types';

export interface LevelProfile {
  id_level_profile: string;
  company: Company;
  name_level_profile: string;
  description_level_profile: string;
  deleted_level_profile: boolean;
}
