import {
  Box,
  Collapsible,
  Divider,
  LabeledList,
  Section,
  Stack,
} from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import { Objective } from './common/Objectives';

type Data = {
  color: string;
  description: string;
  effects: string;
  name: string;
  objectives: Objective[];
};

const BLOB_COLOR = '#556b2f';

export const AntagInfoBlob = (props) => {
  return (
    <Window width={400} height={550}>
      <Window.Content>
        <Section fill scrollable>
          <Overview />
          <Divider />
          <Basics />
          <Structures />
          <Minions />
          <ObjectiveDisplay />
        </Section>
      </Window.Content>
    </Window>
  );
};

const Overview = (props) => {
  const { data } = useBackend<Data>();
  const { color, description, effects, name } = data;

  if (!name) {
    return (
      <Stack vertical>
        <Stack.Item bold fontSize="14px" textColor={BLOB_COLOR}>
          Вы еще не показали свою истинную форму!
        </Stack.Item>
        <Stack.Item>
          Вы должны поглотиться инфекцией. Найдите безопасное место и лопните!
        </Stack.Item>
      </Stack>
    );
  }

  return (
    <Stack vertical>
      <Stack.Item bold fontSize="24px" textColor={BLOB_COLOR}>
        Вы - Блоб!
      </Stack.Item>
      <Stack.Item>Вы сверхразум, управляющий блобом.</Stack.Item>
      <Stack.Item>
        Реагент вашего блоба:{' '}
        <span
          style={{
            color,
          }}
        >
          {name}
        </span>
      </Stack.Item>
      <Stack.Item>
        Реагент{' '}
        <span
          style={{
            color,
          }}
        >
          {name}
        </span>{' '}
        {description}
      </Stack.Item>
      {effects && (
        <Stack.Item>
          Реагент{' '}
          <span
            style={{
              color,
            }}
          >
            {name}
          </span>{' '}
          {effects}
        </Stack.Item>
      )}
    </Stack>
  );
};

const Basics = (props) => {
  return (
    <Collapsible title="Основы">
      <LabeledList>
        <LabeledList.Item label="Атака">
          Вы можете распространятся, что приведет к атаке существ, повреждению
          предметов или размещению Обычного Блоба, если тайл пустой.
        </LabeledList.Item>
        <LabeledList.Item label="Размещение">
          Вы можете вручную разместить ядро блоба, нажав кнопку Разместить Ядро
          Блоба в правом нижнем углу экрана. <br />
          <br />
          Если вы блоб-инфицированный, вы можете разместить ядро там, где вы
          стоите нажав на кнопку в левом верхнем углу экрана.
        </LabeledList.Item>
        <LabeledList.Item label="Интерфейс">
          В дополнение к кнопкам на вашем интерфейсе, есть несколько сочетаний
          клавиш для ускорения расширения и обороны.
        </LabeledList.Item>
        <LabeledList.Item label="Сочетания клавиш">
          Клик = Разместить блоба <br />
          СКМ = Отправить споры <br />
          Контрл-Клик = Создать защитного блоба <br />
          Альт-Клик = Убрать блоба <br />
        </LabeledList.Item>
        <LabeledList.Item label="Связь">
          Попытка коммуникации отправит сообщение всем сверхразумам, для
          совместной координации.
        </LabeledList.Item>
      </LabeledList>
    </Collapsible>
  );
};

const Minions = (props) => {
  return (
    <Collapsible title="Миньоны">
      <LabeledList>
        <LabeledList.Item label="Блоббернауты">
          Боевая единица производимая на фабриках за определенную стоимость.
          Мощные и крепкие, и даже в меру умные. Фабрика, использованная для
          производства - станет хрупкой, временно теряя способность производить
          споры.
        </LabeledList.Item>
        <LabeledList.Item label="Споры">
          Автоматически производятся на фабриках, слабы, но их все можно послать
          на врагов. Они также будут атаковать врагов рядом с фабриками и
          зомбифицировать трупы.
        </LabeledList.Item>
      </LabeledList>
    </Collapsible>
  );
};

const Structures = (props) => {
  return (
    <Collapsible title="Сооружения">
      <Box>
        Блобы для вашего распространения. Могут быть улучшены до
        специализированных блобов. Имейте ввиду, расширение в космос с
        вероятностью 80% не удастся!
      </Box>
      <br />
      <Box>Вы можете превратить обычных блобов в следующие типы:</Box>
      <Divider />
      <LabeledList>
        <LabeledList.Item label="Сильный блоб">
          Сильные блобы стоят дороже, но наносят больше урона. Кроме того, они
          огнеупорные и могут блокировать воздух, используйте их, чтобы
          защититься от пожаров на станции.
        </LabeledList.Item>
        <LabeledList.Item label="Отражающий блоб">
          Улучшение сильного блоба создает блоба, отражающего большинство
          снарядов, ценой увеличенного здоровья.
        </LabeledList.Item>
        <LabeledList.Item label="Ресурсные блобы">
          Блобы, производящие для вас ресурсы, стройте их как можно больше для
          поглощения станции. Размещается рядом с узлами или ядром.
        </LabeledList.Item>
        <LabeledList.Item label="Фабричные блобы">
          Блобы, порождающие споры, атакующие ближайших врагов. Размещаются
          рядом с узлами или ядром.
        </LabeledList.Item>
        <LabeledList.Item label="Узлы блоба">
          Блоб, распространяющийся как ядро. Как и ядро, могут активировать
          ресурсных и фабричных блобов.
        </LabeledList.Item>
      </LabeledList>
    </Collapsible>
  );
};

const ObjectiveDisplay = (props) => {
  const { data } = useBackend<Data>();
  const { color, objectives } = data;

  return (
    <Collapsible title="Задачи">
      <LabeledList>
        {objectives.map(({ explanation }, index) => (
          <LabeledList.Item
            color={color ?? 'white'}
            key={index}
            label={(index + 1).toString()}
          >
            {explanation}
          </LabeledList.Item>
        ))}
      </LabeledList>
    </Collapsible>
  );
};
