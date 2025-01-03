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
          Вы должны умереть от инфекции. Найдите безопасное место и взорвитесь!
        </Stack.Item>
      </Stack>
    );
  }

  return (
    <Stack vertical>
      <Stack.Item bold fontSize="24px" textColor={BLOB_COLOR}>
        Вы - Блоб!
      </Stack.Item>
      <Stack.Item>
        В роли управляющего ядра вы можете управлять блобом.
      </Stack.Item>
      <Stack.Item>
        Ваш реагент блоба:{' '}
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
          Вы можете расширяться, что приведет к атаке существ, повреждению
          предметов или помещению обычной клетки блоба, если тайл пустой.
        </LabeledList.Item>
        <LabeledList.Item label="Размещение">
          Вы сможете вручную разместить ядро блоба, нажав кнопку Place Blob Core
          в правом нижнем углу экрана. <br />
          <br />
          Если вы являетесь блоб-инфекцией, вы можете разместить ядро там, где
          вы стоите нажав на кнопку в левом верхнем углу экрана. экрана.
        </LabeledList.Item>
        <LabeledList.Item label="Интерфейс">
          В дополнение к кнопкам на вашем интерфейсе, есть несколько сочетаний
          клавиш для ускорения расширения и обороны.
        </LabeledList.Item>
        <LabeledList.Item label="Сочетания клавиш">
          Клик = Разместить клетку блоба <br />
          СКМ = Отправить споры <br />
          Ктрл-Клик = Создать щитовую клетку блоба <br />
          Альт-Клик = Убрать клетку блоба <br />
        </LabeledList.Item>
        <LabeledList.Item label="Связь">
          Попытка заговорить отправит сообщение всем остальным управляющим
          ядрам, что позволит вам координировать свои действия с ними.
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
          Эта боевая единица может быть произведена на клетках-фабриках за
          определенную стоимость. Их трудно убить, мощные и в меру умные.
          Фабрика, использованная для создания одного станет хрупкой и на
          короткое время потеряет способность производить споры.
        </LabeledList.Item>
        <LabeledList.Item label="Споры">
          Они производятся автоматически на клетках-фабриках, слабы, но их можно
          собрать воедино и атаковать врагов. Они также будут атаковать врагов
          рядом с фабрики и пытаются зомбировать трупы.
        </LabeledList.Item>
      </LabeledList>
    </Collapsible>
  );
};

const Structures = (props) => {
  return (
    <Collapsible title="Сооружения">
      <Box>
        Обычные клетки блоба расширят ваши границы и могут быть улучшены до
        специальных клеток блоба, которые выполняют определенные функции. Имейте
        в виду, что расширение в космос с вероятностью 80% не удастся!
      </Box>
      <br />
      <Box>Вы можете превратить обычные клетки блоба в следующие типы:</Box>
      <Divider />
      <LabeledList>
        <LabeledList.Item label="Сильные клетки блоба">
          Сильные клетки блоба стоят дороже, но наносят больше урона. Кроме
          того, они огнеупорные и могут блокировать воздух, используйте их,
          чтобы защититься от пожаров на станции.
        </LabeledList.Item>
        <LabeledList.Item label="Отражающие клетки блоба">
          Улучшение сильных клеток блоба создает отражающие клетки блоба,
          способные отражать большинство снарядов за счет дополнительного
          здоровья сильной клетки блоба.
        </LabeledList.Item>
        <LabeledList.Item label="Ресурсные клетки блоба">
          Клетки блоба, которые производят больше ресурсов для вас, постройте их
          как можно больше, чтобы поглощать станцию. Этот тип блобов должен быть
          размещен рядом с узловыми клетками блоба или ядра, чтобы они работали.
        </LabeledList.Item>
        <LabeledList.Item label="Клетки-фабрики блоба">
          Клетки блоба, которые порождают споры блоба, которые атакуют ближайших
          врагов. Эти клетки блоба необходимо поместить рядом с узловыми
          клетками блоба или ядром, чтобы они работали.
        </LabeledList.Item>
        <LabeledList.Item label="Узловые клетки блоба">
          Клетки блоба, которые растут, как и ядро. Они, как и ядро, могут
          активировать ресурсные клетки и клетки-фабрики блоба.
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
