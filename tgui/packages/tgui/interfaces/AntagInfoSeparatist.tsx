import { Icon, Section, Stack } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import { Objective, ObjectivePrintout } from './common/Objectives';

type Info = {
  objectives: Objective[];
  nation: string;
  nationColor: string;
};

export const AntagInfoSeparatist = (props) => {
  const { data } = useBackend<Info>();
  const { nationColor } = data;
  return (
    <Window width={620} height={450}>
      <Window.Content backgroundColor={nationColor}>
        <Stack vertical fill>
          <Stack.Item grow>
            <IntroductionObjectives />
          </Stack.Item>
          <Stack.Item>
            <FrequentlyAskedQuestions />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const IntroductionObjectives = (props) => {
  const { data } = useBackend<Info>();
  const { nation, objectives } = data;
  return (
    <Section fill>
      <Stack vertical>
        <Stack.Item textColor="red" fontSize="20px">
          Вы - Борец за свободу {nation}!
        </Stack.Item>
        <Stack.Item grow>
          <ObjectivePrintout
            objectives={objectives}
            titleMessage={`Задачи ${nation}:`}
          />
        </Stack.Item>
      </Stack>
    </Section>
  );
};

const FrequentlyAskedQuestions = (props) => {
  const { data } = useBackend<Info>();
  const { nation } = data;
  return (
    <Section fill>
      <Stack vertical>
        <Stack.Item fontSize="18px" bold>
          <Icon name="info" color="label" /> Часто задаваемые вопросы:
        </Stack.Item>
        <Stack.Item fontSize="16px">
          &quot;Что вообще такое Сепаратист?&quot;
        </Stack.Item>
        <Stack.Item>
          Сепаратисты - это полуантагонисты, которыми заполнен каждый отдел
          когда начинается раунд. Они не имеют права свободно ходить и убивать,
          а защищают суверенитет своего департамента. Вы можете даже узнать их
          по их историческому режиму, в котором они когда-то существовали:
          Нации!
        </Stack.Item>
        <Stack.Item fontSize="16px">
          &quot;Что я должен делать?&quot;
        </Stack.Item>
        <Stack.Item>
          У каждого отдела (нации) есть своя цель. Это условная задача, поэтому
          старайтесь следовать ей так же, как и условной задаче Абдуктора. Как
          показывает опыт, в конце концов нации конфликтуют и перерастают в
          войну. До тех пор пока оба департамента знают, почему конфликт
          начинается, то это зеленый свет для нападения на противоборствующие
          нации.
        </Stack.Item>
        <Stack.Item fontSize="16px">
          &quot;{nation} - самая лучшая нация?&quot;
        </Stack.Item>
        <Stack.Item>Да.</Stack.Item>
      </Stack>
    </Section>
  );
};
