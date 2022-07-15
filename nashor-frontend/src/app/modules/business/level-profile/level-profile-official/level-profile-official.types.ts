import { Official } from '../../official/official.types';
import { LevelProfile } from '../level-profile.types';

export interface LevelProfileOfficial {
  id_level_profile_official: string;
  level_profile: LevelProfile;
  official: Official;
  official_modifier: boolean;
  number_task?: number;

  isSelected?: boolean;
}
