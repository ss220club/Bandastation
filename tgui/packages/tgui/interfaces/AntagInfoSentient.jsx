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
                Все сразу становится понятно: вы знаете, что вы есть и кто вы!
                Самосознание стало вашим!
                {!!enslaved_to &&
                  ' Вы благодарны за то, что осознаете себя и обязаны ' +
                    enslaved_to +
                    ' большой долг. Служить ' +
                    enslaved_to +
                    ', и помогать ' +
                    p_them +
                    ' в завершении ' +
                    p_their +
                    ' целей любой ценой.'}
                {!!holographic &&
                  ' Вы также удручающе осознаете, что являетесь не реальным существом, а голоформой. Ваше существование ограничено параметрами голодека.'}
              </BlockQuote>
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
