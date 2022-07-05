import { Company } from 'app/modules/core/company/company.types';
import { LevelProfile } from '../level-profile/level-profile.types';
import { LevelStatus } from '../level-status/level-status.types';
import { Template } from '../template/template.types';

export interface Level {
  id_level: string;
  company: Company;
  template: Template;
  level_profile: LevelProfile;
  level_status: LevelStatus;
  name_level: string;
  description_level: string;
  deleted_level: boolean;
  isSelected?: boolean;
}
