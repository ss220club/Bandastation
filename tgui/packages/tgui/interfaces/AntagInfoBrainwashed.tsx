import { Box, Icon, Section, Stack } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import { Objective, ObjectivePrintout } from './common/Objectives';

type Data = {
  objectives: Objective[];
};

export const AntagInfoBrainwashed = (porps) => {
  const { data } = useBackend<Data>();

  return (
    <Window width={400} height={400} theme="abductor">
      <Window.Content backgroundColor="#722e7d">
        <Icon
          size={16}
          name="flushed"
          color="#3f1945"
          position="absolute"
          top="42%"
          left="26%"
        />
        <Section fill>
          <Stack vertical fill textAlign="center">
            <Stack.Item fontFamily="Wingdings">
              Эй, не смейте! Хватит транслировать это!
            </Stack.Item>
            <Stack.Item mt={-0.25} fontSize="20px">
              Ваши мысли разбегаются...
            </Stack.Item>
            <Stack.Item mt={-0.25} fontSize="20px">
              Сосредоточен на одной цели...
            </Stack.Item>
            <Stack.Item mt={3.5} grow>
              <ObjectivePrintout
                fill
                objectives={data.objectives}
                objectiveFollowup={
                  <Box bold textColor="red">
                    Необходимо следовать этой директиве.
                  </Box>
                }
              />
            </Stack.Item>
            <Stack.Item fontSize="20px" textColor="#61e4b9">
              Выполняйте директивы любой ценой!
            </Stack.Item>
            <Stack.Item fontFamily="Wingdings">
              Ты испортил мой классный эффект шрифта.
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
