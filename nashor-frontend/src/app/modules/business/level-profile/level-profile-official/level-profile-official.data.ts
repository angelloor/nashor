import { levelProfile } from '../level-profile.data';
import { official } from '../../official/official.data';
import { LevelProfileOfficial } from './level-profile-official.types';

export const levelProfileOfficials: LevelProfileOfficial[] = [];
export const levelProfileOfficial: LevelProfileOfficial = {
  id_level_profile_official: ' ',
  level_profile: levelProfile,
  official: official,
  official_modifier: false,
};
