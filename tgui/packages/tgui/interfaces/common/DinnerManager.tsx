import { Button, Flex, Section, Stack } from 'tgui-core/components';

import { useBackend } from '../../backend';

type DinnerType = {
  dinner_name: string;
  dinner_ready: boolean;
  dinner_cooldown: number;
};

type Data = {
  dinner_types: DinnerType[];
  station_code_allowed: boolean;
};

export const DinnerManager = () => {
  const { act, data } = useBackend<Data>();
  const { dinner_types, station_code_allowed } = data;

  return (
    <Stack vertical>
      <Section title="Обеденный Справочник">
        <Stack.Item textColor="label">
          Назначьте обед для одного или нескольких отделов или назначьте обед
          для всех отделов сразу.
          <br />
          Обед нельзя назначить если код безопатности выше синего.
          <br />
          Для каждого отдела обед можно назначить через 45 минут после начала
          смены и через 45 минут после прошлого обеда.
          <br />
          Если назначить обед для всех отделов сразу то остальные кнопки так-же
          уйдут на перезарядку.
        </Stack.Item>
      </Section>
      <Section title="Обеденный Менеджер">
        {!station_code_allowed ? (
          <Stack.Item textColor="label">
            Объявить обед невозможно в связи с высоким уровнем кода
            безопастности
          </Stack.Item>
        ) : (
          <Flex direction="column" align="stretch">
            {dinner_types.map((dinner, index) => (
              <Flex.Item key={index} mb={1}>
                <Button
                  icon={dinner.dinner_ready ? 'check-circle' : 'times-circle'}
                  color={dinner.dinner_ready ? 'good' : 'bad'}
                  content={`Обед для ${dinner.dinner_name}${!dinner.dinner_ready ? ' - ' + dinner.dinner_cooldown + ' мин.' : ''}`}
                  onClick={() =>
                    act('toggleDinnerReady', {
                      dinner_name: dinner.dinner_name,
                      is_ready: dinner.dinner_ready,
                      cooldown: dinner.dinner_cooldown,
                    })
                  }
                />
              </Flex.Item>
            ))}
          </Flex>
        )}
      </Section>
    </Stack>
  );
};
