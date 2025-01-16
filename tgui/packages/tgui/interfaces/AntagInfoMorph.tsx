import { BlockQuote, Stack } from 'tgui-core/components';

import { Window } from '../layouts';

const goodstyle = {
  color: 'lightgreen',
};

const badstyle = {
  color: 'red',
};

const noticestyle = {
  color: 'lightblue',
};

export const AntagInfoMorph = (props) => {
  return (
    <Window width={620} height={190} theme="abductor">
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item fontSize="25px">Вы - Морф...</Stack.Item>
          <Stack.Item>
            <BlockQuote>
              ...мерзость, способная съесть почти все. Вы можете принимать форму
              всего, что увидели{' '}
              <span style={noticestyle}>
                используя способность &quot;Assume Form&quot; на нем. Шифт-клик
                по обьекту тоже будет работать.
              </span>{' '}
              <span style={badstyle}>
                &ensp;Этот процесс предупредит всех находящихся поблизости.
              </span>{' '}
              Превратившись, вы двигаетесь быстрее, но не можете атаковать
              существ или есть. Кроме того,
              <span style={badstyle}>
                &ensp;любой в радиусе трех тайлов заметит странную
                неправильность при осмотре.
              </span>{' '}
              Вы можете атаковать любой предмет или мертвое существо, чтобы
              поглотить его -
              <span style={goodstyle}>
                &ensp;трупы восстанавливают ваше здоровье.
              </span>{' '}
              Наконец, вы можете вернуть себе прежнюю форму, будучи
              перевоплощенным{' '}
              <span style={noticestyle}>
                используя способность &quot;Assume Form&quot; на себе. Вы также
                можете шифт-кликнуть себя.
              </span>{' '}
            </BlockQuote>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
