import { multiline } from 'common/string';

import { Antagonist, Category } from '../base';

const Spy: Antagonist = {
  key: 'spy',
  name: 'Шпион',
  description: [
    multiline`
      Ваша миссия, если вы решитесь взяться за нее: проникнуть на космическую станцию 13.
      Замаскируйтесь под ее члена экипажа и украдите жизненно важное оборудование.
      Если вас поймают или убьют, ваш работодатель будет отрицать любую информацию,
      связанную с вашими действиями тут. Удачи, агент.
    `,

    multiline`
      Выполняйте шпиноские заказы, чтобы заработать награды от вашего работодателя.
      Используйте эти награды для того, чтобы сеять хаос и беду!
    `,
  ],
  category: Category.Roundstart,
};

export default Spy;
