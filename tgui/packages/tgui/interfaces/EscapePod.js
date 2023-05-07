import { useBackend } from '../backend';
import { Box, Button, Section } from '../components';
import { Window } from '../layouts';

export const EscapePod = (props, context) => {
  const { act, data } = useBackend(context);
  return (
    <Window
      title="Эвакуационная Капсула"
      width={600}
      height={1400}>
      <Window.Content>
        <Section title="Эвакуация">
          Добро пожаловать!
          <Box
            width="100%"
            textAlign="center">
            <Button.Confirm
              m="50"
              content="Запустить Процесс"
              color="red"
              onClick={() => act('launch')} />
          </Box>
        </Section>
      </Window.Content>
    </Window>
  );
};
