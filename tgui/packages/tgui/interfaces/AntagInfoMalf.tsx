import { useState } from 'react';
import { BlockQuote, Button, Section, Stack, Tabs } from 'tgui-core/components';
import { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import {
  Objective,
  ObjectivePrintout,
  ReplaceObjectivesButton,
} from './common/Objectives';
import { GenericUplink, Item } from './Uplink/GenericUplink';

const allystyle = {
  fontWeight: 'bold',
  color: 'yellow',
};

const badstyle = {
  color: 'red',
  fontWeight: 'bold',
};

const goalstyle = {
  color: 'lightgreen',
  fontWeight: 'bold',
};

type Info = {
  has_codewords: BooleanLike;
  phrases: string;
  responses: string;
  theme: string;
  allies: string;
  goal: string;
  intro: string;
  processingTime: string;
  objectives: Objective[];
  categories: any[];
  can_change_objective: BooleanLike;
};

const IntroductionSection = (props) => {
  const { act, data } = useBackend<Info>();
  const { intro, objectives, can_change_objective } = data;
  return (
    <Section fill title="Интро" scrollable>
      <Stack vertical fill>
        <Stack.Item fontSize="25px">{intro}</Stack.Item>
        <Stack.Item grow>
          <ObjectivePrintout
            objectives={objectives}
            titleMessage="Ваши основные задачи:"
            objectivePrefix="&#8805-"
            objectiveFollowup={
              <ReplaceObjectivesButton
                can_change_objective={can_change_objective}
                button_title={'Перезапись данных о целях'}
                button_colour={'green'}
              />
            }
          />
        </Stack.Item>
      </Stack>
    </Section>
  );
};

const FlavorSection = (props) => {
  const { data } = useBackend<Info>();
  const { allies, goal } = data;
  return (
    <Section
      fill
      title="Диагностика"
      buttons={
        <Button
          mr={-0.8}
          mt={-0.5}
          icon="hammer"
          tooltip={`
            Это предложение по геймплею для скучающих ИИшек.
            Вы не обязаны следовать ему, если только вам не нужны
            идеи, как провести раунд.`}
          tooltipPosition="bottom-start"
        >
          Policy
        </Button>
      }
    >
      <Stack vertical fill>
        <Stack.Item grow>
          <Stack fill vertical>
            <Stack.Item style={{ backgroundColor: 'black' }}>
              <span style={goalstyle}>
                Отчет о целостности системы:
                <br />
              </span>
              &gt;{goal}
            </Stack.Item>
            <Stack.Divider />
            <Stack.Item grow style={{ backgroundColor: 'black' }}>
              <span style={allystyle}>
                Доклад ядра морали:
                <br />
              </span>
              &gt;{allies}
            </Stack.Item>
            <Stack.Divider />
            <Stack.Item style={{ backgroundColor: 'black' }}>
              <span style={badstyle}>
                Общая оценка согласованности чувств: НЕУДАЧА.
                <br />
              </span>
              &gt;Сообщить в Нанотрейзен?
              <br />
              &gt;&gt;N
            </Stack.Item>
          </Stack>
        </Stack.Item>
      </Stack>
    </Section>
  );
};

const CodewordsSection = (props) => {
  const { data } = useBackend<Info>();
  const { has_codewords, phrases, responses } = data;
  return (
    <Section title="Кодовые слова" mb={!has_codewords && -1}>
      <Stack fill>
        {(!has_codewords && (
          <BlockQuote>
            Вам не предоставили кодовые слова Синдиката. Вам придется
            использовать альтернативные методы поиска потенциальных союзников.
            Действуйте с осторожностью, ведь каждый - потенциальный враг.
          </BlockQuote>
        )) || (
          <>
            <Stack.Item grow basis={0}>
              <BlockQuote>
                Благодаря новому доступу к закрытым каналам вы получили
                перехваченные кодовые слова Синдиката. Агенты синдиката будут
                отвечать как будто вы один из них. Действуйте с осторожностью,
                поскольку каждый из них - потенциальный враг.
                <span style={badstyle}>
                  &ensp;Подсистема распознавания речи была настроена на то,
                  чтобы отмечать эти кодовые слова.
                </span>
              </BlockQuote>
            </Stack.Item>
            <Stack.Divider mr={1} />
            <Stack.Item grow basis={0}>
              <Stack vertical>
                <Stack.Item>Кодовые фразы:</Stack.Item>
                <Stack.Item bold textColor="blue">
                  {phrases}
                </Stack.Item>
                <Stack.Item>Кодовые ответы:</Stack.Item>
                <Stack.Item bold textColor="red">
                  {responses}
                </Stack.Item>
              </Stack>
            </Stack.Item>
          </>
        )}
      </Stack>
    </Section>
  );
};

export const AntagInfoMalf = (props) => {
  const { act, data } = useBackend<Info>();
  const { processingTime, categories } = data;
  const [antagInfoTab, setAntagInfoTab] = useState(0);
  const categoriesList: string[] = [];
  const items: Item[] = [];
  for (let i = 0; i < categories.length; i++) {
    const category = categories[i];
    categoriesList.push(category.name);
    for (let itemIndex = 0; itemIndex < category.items.length; itemIndex++) {
      const item = category.items[itemIndex];
      items.push({
        id: item.name,
        name: item.name,
        icon: item.icon,
        icon_state: item.icon_state,
        category: category.name,
        cost: `${item.cost} ВО`,
        desc: item.desc,
        disabled: processingTime < item.cost,
      });
    }
  }
  return (
    <Window
      width={660}
      height={530}
      theme={(antagInfoTab === 0 && 'hackerman') || 'malfunction'}
    >
      <Window.Content style={{ fontFamily: 'Consolas, monospace' }}>
        <Stack vertical fill>
          <Stack.Item>
            <Tabs fluid>
              <Tabs.Tab
                icon="info"
                selected={antagInfoTab === 0}
                onClick={() => setAntagInfoTab(0)}
              >
                Информация
              </Tabs.Tab>
              <Tabs.Tab
                icon="code"
                selected={antagInfoTab === 1}
                onClick={() => setAntagInfoTab(1)}
              >
                Сбойные Модули
              </Tabs.Tab>
            </Tabs>
          </Stack.Item>
          {(antagInfoTab === 0 && (
            <>
              <Stack.Item grow>
                <Stack fill>
                  <Stack.Item width="70%">
                    <IntroductionSection />
                  </Stack.Item>
                  <Stack.Item width="30%">
                    <FlavorSection />
                  </Stack.Item>
                </Stack>
              </Stack.Item>
              <Stack.Item>
                <CodewordsSection />
              </Stack.Item>
            </>
          )) || (
            <Stack.Item>
              <Section>
                <GenericUplink
                  categories={categoriesList}
                  items={items}
                  currency={`${processingTime} ВО`}
                  handleBuy={(item) => act('купить', { name: item.name })}
                />
              </Section>
            </Stack.Item>
          )}
        </Stack>
      </Window.Content>
    </Window>
  );
};
