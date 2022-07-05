import { level } from '../../../level/level.data';
import { flowVersion } from '../flow-version.data';
import { FlowVersionLevel } from './flow-version-level.types';

export const flowVersionLevels: FlowVersionLevel[] = [];
export const flowVersionLevel: FlowVersionLevel = {
  id_flow_version_level: ' ',
  flow_version: flowVersion,
  level: level,
  position_level: 1,
  is_level: false,
  is_go: false,
  is_finish: false,
  is_conditional: false,
  type_conditional: 'value_replace_1',
  expression: ' ',
};
