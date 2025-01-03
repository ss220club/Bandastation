import { Feature } from '../../base';
import { FeatureDropdownInput } from '../../dropdowns';

export const lobby_style: Feature<string> = {
  name: 'Lobby Style',
  category: 'UI',
  component: FeatureDropdownInput,
};
