import { company } from 'app/modules/core/company/company.data';
import { user } from 'app/modules/core/user/user.data';
import { area } from '../area/area.data';
import { position } from '../position/position.data';
import { Official } from './official.types';

export const officials: Official[] = [];
export const official: Official = {
  id_official: ' ',
  company: company,
  user: user,
  area: area,
  position: position,
  deleted_official: false,
};
