import { BlockQuote, LabeledList, Section, Stack } from 'tgui-core/components';

import { Window } from '../layouts';

const tipstyle = {
  color: 'white',
};

const noticestyle = {
  color: 'lightblue',
};

export const AntagInfoNightmare = (props) => {
  return (
    <Window width={620} height={380}>
      <Window.Content backgroundColor="#0d0d0d">
        <Stack fill>
          <Stack.Item width="46.2%">
            <Section fill>
              <Stack vertical fill>
                <Stack.Item fontSize="25px">Вы - Кошмар.</Stack.Item>
                <Stack.Item>
                  <BlockQuote>
                    Вы - существо, пришедшее из-за звезд, которое обладает
                    невероятно сильными способностями во тьме, становясь почти
                    непобедимым. К сожалению, на свету вы ослабеваете и
                    сгораете. Вы должны использовать свой
                    <span style={noticestyle}>&ensp;пожиратель света</span>,
                    чтобы погасить станцию, делая охоту проще.
                  </BlockQuote>
                </Stack.Item>
                <Stack.Divider />
                <Stack.Item textColor="label">
                  <span style={tipstyle}>Совет #1:&ensp;</span>
                  Перемещайтесь чаще. Станция будет охотиться за вами после
                  того, как вас обнаружат, поэтому не задерживайтесь надолго в
                  одном месте.
                  <br />
                  <span style={tipstyle}>Совет #2:&ensp;</span>
                  Выбирайте нечестные бои. Вы невероятно сильны в ситуациях
                  «один на один», используйте это. Чем больше вы сражаетесь, тем
                  сложнее будет вам сохранять и придерживатся в темноте.
                  <br />
                  <span style={tipstyle}>Совет #3:&ensp;</span>
                  Полностью уничтожайте ЛКП, когда это возможно. Вместо того
                  чтобы охотиться на лампы, которые можно починить, охотьтесь на
                  ЛКП, которые сложнее починить.
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>
          <Stack.Item width="53%">
            <Section fill title="Ваши способности">
              <LabeledList>
                <LabeledList.Item label="Shadow Dance">
                  Находясь в тени, вы невосприимчивы ко всем атакам дальнего
                  боя, а также быстро восстанавливаете здоровье.
                </LabeledList.Item>
                <LabeledList.Item label="Shadow Walk">
                  Вам позволено неограниченное, ничем не ограниченное движение в
                  темноте. Свет вытащит вас из этого состояния.
                </LabeledList.Item>
                <LabeledList.Item label="Heart of Darkness">
                  Ваше сердце призывает тени. Если вы умрете во тьме, то в конце
                  концов оживете, если вас оставят в покое.
                </LabeledList.Item>
                <LabeledList.Item label="Light Eater">
                  Ваш искаженный отросток. Он поглотит свет всего, к чему
                  прикоснется будь то жертва или предмет. После 7 секунд
                  пребывания в перемещении по темноте, удар по противнику
                  оглушит его или нанесёт дополнительный урон.
                </LabeledList.Item>
              </LabeledList>
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
