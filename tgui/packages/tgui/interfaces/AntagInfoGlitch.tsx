import { Divider, Section, Stack } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import { Objective } from './common/Objectives';

type Data = {
  antag_name: string;
  objectives: Objective[];
};

const textStyles = {
  variable: {
    color: 'white',
  },
  danger: {
    color: 'red',
  },
} as const;

export const AntagInfoGlitch = (props) => {
  const { data } = useBackend<Data>();
  const { antag_name, objectives = [] } = data;

  return (
    <Window width={350} height={450} theme="ntos_terminal">
      <Window.Content>
        <Section scrollable fill>
          <Stack fill vertical>
            <Stack.Item>FN ТЕРМИНАЦИЯ_НАРУШИТЕЛЕЙ (REF)</Stack.Item>
            <Divider />
            <Stack.Item mb={1} bold fontSize="16px">
              <span style={textStyles.variable}>
                Инициализация({antag_name})
              </span>
            </Stack.Item>
            <Stack.Item mb={2}>
              <span style={textStyles.danger}>Битраннинг</span>- это
              преступление. Ваша миссия:{' '}
              <span style={textStyles.variable}>Уничтожить</span> органических
              вторженцов, чтобы сохранить целостность системы.
            </Stack.Item>
            <SpecificInfo />
            <Stack.Item>
              <marquee scrollamount="2">{objectives[0]?.explanation}</marquee>
            </Stack.Item>
            <Divider />
            <Stack.Item>
              константа <span style={textStyles.variable}>ЦЕЛИ</span> ={' '}
            </Stack.Item>
            <Stack.Item>
              <span style={textStyles.variable}>системы.</span>
              <span style={textStyles.danger}>ВТОРЖЕНЦЫ</span>;
            </Stack.Item>
            <Stack.Item>
              когда <span style={textStyles.variable}>ЦЕЛИ</span>.ЖИЗНЬ !={' '}
              <span style={textStyles.variable}>статус.</span>МЕРТВ
            </Stack.Item>
            <Stack.Item>
              <span style={textStyles.variable}>действие.</span>
              <span style={textStyles.danger}>УБИТЬ()</span>
            </Stack.Item>
            <Stack.Item>уничтожить_вторженцев([0x70cf4020])</Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};

const SpecificInfo = (props) => {
  const { data } = useBackend<Data>();
  const { antag_name } = data;

  switch (antag_name) {
    case 'Cyber Police':
      return (
        <>
          <Stack.Item mb={2}>
            Чтобы облегчить вам задачу, в вашу программу добавлены передовые
            технологии знаний{' '}
            <span style={textStyles.variable}>боевых исскуств</span>.
          </Stack.Item>
          <Stack.Item grow>
            Оружие дальнего боя <span style={textStyles.danger}>запрещено</span>
            . Баллистическая защита не приветствуется. Стиль имеет
            первостепенное значение.
          </Stack.Item>
        </>
      );
    case 'Cyber Tac':
      return (
        <>
          <Stack.Item mb={2}>
            Вы - передовое боевое подразделение. Вы были оснащены{' '}
            <span style={textStyles.variable}>летальным оружие</span>.
          </Stack.Item>
          <Stack.Item grow>
            <span style={textStyles.danger}>Уничтожить</span> органическую жизнь
            любой любой ценой.
          </Stack.Item>
        </>
      );
    case 'NetGuardian Prime':
      return (
        <Stack.Item grow>
          <span style={{ ...textStyles.danger, fontSize: '16px' }}>
            ОРГАНИЧЕСКАЯ ЖИЗНЬ ДОЛЖНА БЫТЬ ЛИКВИДИРОВАНА.
          </span>
        </Stack.Item>
      );
    default:
      return null;
  }
};
