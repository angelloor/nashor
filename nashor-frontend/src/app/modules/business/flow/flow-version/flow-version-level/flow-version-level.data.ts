import { level } from 'app/modules/business/level/level.data';
import { flowVersion } from '../flow-version.data';
import { FlowVersionLevel } from './flow-version-level.types';

export const flowVersionLevels: FlowVersionLevel[] = [];
export const flowVersionLevel: FlowVersionLevel = {
  id_flow_version_level: ' ',
  flow_version: flowVersion,
  level: level,
  position_level: 1,
  position_level_father: 1,
  type_element: 'level',
  id_control: ' ',
  operator: '==',
  value_against: ' ',
  option_true: false,
  x: '',
  y: '',
};
