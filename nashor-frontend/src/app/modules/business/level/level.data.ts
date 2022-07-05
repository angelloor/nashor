import { company } from 'app/modules/core/company/company.data';
import { levelProfile } from '../level-profile/level-profile.data';
import { levelStatus } from '../level-status/level-status.data';
import { template } from '../template/template.data';
import { Level } from './level.types';

export const levels: Level[] = [];
export const level: Level = {
  id_level: ' ',
  company: company,
  template: template,
  level_profile: levelProfile,
  level_status: levelStatus,
  name_level: ' ',
  description_level: ' ',
  deleted_level: false,
};
