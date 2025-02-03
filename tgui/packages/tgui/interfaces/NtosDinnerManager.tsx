import { NtosWindow } from '../layouts';
import { DinnerManager } from './common/DinnerManager';

export const NtosDinnerManager = () => {
  return (
    <NtosWindow width={400} height={650}>
      <NtosWindow.Content>
        <DinnerManager />
      </NtosWindow.Content>
    </NtosWindow>
  );
};
