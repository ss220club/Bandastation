import { CheckboxInput, FeatureToggle } from '../../base';

export const donor_public: FeatureToggle = {
  name: 'Publicize Donor status',
  category: 'CHAT',
  description:
    'When enabled, a donor badge will be shown next to your name in OOC.',
  component: CheckboxInput,
};
