import { Chart, ProgressBar, Section } from '../components';
import { Window } from '../layouts';
import { useBackend } from '../backend';

export const RbmkStats = (props, context) => {
  const { data } = useBackend(context);
  const powerData = data.powerData.map((value, i) => [i, value]);
  const temperatureData = data.temperatureData.map((value, i) => [i, value]);
  return (
    <Window resizable theme="ntos" width={350} height={500}>
      <Window.Content>
        <Section title="Legend:">
          Reactor Power (%):
          <ProgressBar
            value={data.power}
            minValue={0}
            maxValue={100}
            color="yellow"
          />
          <br />
          temperature (°F):
          <ProgressBar
            value={data.temperature}
            minValue={0}
            maxValue={2000}
            color="bad">
            {data.coolantOutput} °F
          </ProgressBar>
        </Section>
        <Section fill title="Reactor Statistics:" height="200px">
          <Chart.Line
            fillPositionedParent
            data={powerData}
            rangeX={[0, powerData.length - 1]}
            rangeY={[0, 1500]}
            strokeColor="rgba(255, 215,0, 1)"
            fillColor="rgba(255, 215, 0, 0.1)"
          />
          <Chart.Line
            fillPositionedParent
            data={temperatureData}
            rangeX={[0, temperatureData.length - 1]}
            rangeY={[0, 2000]}
            strokeColor="rgba(255, 0, 0 , 1)"
            fillColor="rgba(255, 0, 0 , 0.1)"
          />
        </Section>
      </Window.Content>
    </Window>
  );
};
