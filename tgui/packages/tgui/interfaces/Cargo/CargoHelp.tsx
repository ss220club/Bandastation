import { Box, NoticeBox, Section, Stack } from '../../components';

const ORDER_TEXT = `Работники станции могут делать заказы на соотвествующее
      их отделам снаряжение с помощью специальных консолей. Эти заказы абсолютно
      бесплатны и не тратят средства из бюджета грузового отдела, а лишь имеют
      задержку между повторными заказами. И вот где вы вступаете в игру:
      заказанные ящики появятся на вашей консоли поставок, и вам будет
      необходимо их доставить. Вы будете получать полную стоимость заказа при
      доставке ящика адресату в целости и сохранности, что делает эту систему
      хорошим источником дохода.`;

const DISPOSAL_TEXT = `Помимо MULEботов и ручной доставки, вы также можете
      воспользоваться системой почтовой отправки через трубопровод, который
      так же используется для доставки отходов. Обратите внимание, что разрыв в
      трубопроводе может привести к потере посылки (это случается крайне редко),
      поэтому это не всегда самый безопасный способ доставки. Вы также можете
      завернуть кусок бумаги и отправить его по почте тем же способом, если вы
      (или кто-то на стойке) хотите отправить письмо.`;

export function CargoHelp(props) {
  return (
    <Stack fill vertical>
      <Stack.Item grow>
        <Section fill scrollable>
          <Section color="label" title="Заказы отдела">
            {ORDER_TEXT}
            <br />
            <br />
            Осмотрите ящик с заказом отдела, чтобы получить конкретные детали о
            том, куда именно его нужно доставить.
          </Section>
          <Section title="MULEботы">
            <Box color="label">
              MULEботы - верные роботы-доставщики, которые доставят ящики с
              минимальными усилиями технического персонала. Бот медленный, и по
              этому с ним может случится что-то нехорошее по пути.
            </Box>
            <br />
            <Box bold color="green">
              Настроить MULEбот очень просто:
            </Box>
            <b>1.</b> Разместите ящик рядом с MULEботом.
            <br />
            <b>2.</b> Перетащите ящик на MULEбот. Он будет загружен на него.
            <br />
            <b>3.</b> Откройте ваш ПДА.
            <br />
            <b>4.</b> Откройте приложение <i>BotKeeper</i>.<br />
            <b>5.</b> Найдите необходимого MULEбота.
            <br />
            <b>6.</b> Выберите бота.
            <br />
            <b>7.</b> Нажмите на <i>Set Destination</i>.<br />
            <b>8.</b> Выберите место назначения.
            <br />
            <b>9.</b> Намжите <i>Go to Destination</i> справа сверху.
          </Section>
          <Section title="Доставка с помощью трубопровода">
            <Box color="label">{DISPOSAL_TEXT}</Box>
            <br />
            <Box bold color="green">
              Использование трубопровода еще проще:
            </Box>
            <b>1.</b> Оберните предмет/ящик в упаковочную бумагу.
            <br />
            <b>2.</b> Используйте <i>destinations tagger</i> для выбора места
            доставки.
            <br />
            <b>3.</b> Пометьте посылку.
            <br />
            <b>4.</b> Разместите посылку на конвеер и запустите его.
            <br />
          </Section>
        </Section>
      </Stack.Item>
      <Stack.Item>
        <NoticeBox textAlign="center" info mb={0}>
          Pondering something not included here? When in doubt, ask the QM!
        </NoticeBox>
      </Stack.Item>
    </Stack>
  );
}
