import { BlockQuote, Section, Stack } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

export const AntagInfoSentient = (props) => {
  const { act, data } = useBackend();
  const { enslaved_to, holographic, p_them, p_their } = data;
  return (
    <Window width={400} height={400} theme="neutral">
      <Window.Content>
        <Section fill>
          <Stack vertical fill textAlign="center">
            <Stack.Item fontSize="20px">Вы - разумное существо!</Stack.Item>
            <Stack.Item>
              <BlockQuote>
                Все сразу прояснилось: вы знаете, чем и кем являетесь!
                Самосознание стало вашим!
                {!!enslaved_to &&
                  ' Вы благодарны за самосознание и перед ' +
                    enslaved_to +
                    ' в большом долгу. Служите ' +
                    enslaved_to +
                    ', и помогайте ' +
                    p_them +
                    ' в завершении ' +
                    p_their +
                    ' целей любой ценой.'}
                {!!holographic &&
                  ' Вас удручает от осознания, что вы не реальное существо, а голоформа. Ваше существование ограничено параметрами голодека.'}
              </BlockQuote>
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
