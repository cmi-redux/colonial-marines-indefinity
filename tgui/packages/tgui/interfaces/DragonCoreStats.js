import { Chart, ProgressBar, Section } from '../components';
import { Window } from '../layouts';
import { useBackend } from '../backend';

export const DragonCoreStats = (props, context) => {
  const { data } = useBackend(context);
  const powerData = data.powerData.map((value, i) => [i, value]);
  const temperatureData = data.temperatureData.map((value, i) => [i, value]);
  const vesseltemperatureData = data.vesseltemperatureData.map((value, i) => [
    i,
    value,
  ]);
  const vesselcoolingData = data.vesselcoolingData.map((value, i) => [
    i,
    value,
  ]);
  const temdiffData = data.temdiffData.map((value, i) => [i, value]);
  const shieldData = data.shieldData.map((value, i) => [i, value]);
  return (
    <Window resizable theme="weyland" width={350} height={500}>
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
          Temperature (°F):
          <ProgressBar
            value={data.temperature}
            minValue={0}
            maxValue={110000000}
            color="bad">
            {data.temperature} °F
          </ProgressBar>
          Vessel Temperature (°F):
          <ProgressBar
            value={data.vessel_temperature}
            minValue={0}
            maxValue={11000}
            color="bad">
            {data.vessel_temperature} °F
          </ProgressBar>
          Vessel Shields (Ps^2/R*L):
          <ProgressBar
            value={data.shields}
            minValue={0}
            maxValue={data.max_shields}
            color="bad">
            {data.shields} Ps^2/R*L
          </ProgressBar>
        </Section>
        <Section fill title="Reactor Statistics:" height="200px">
          <Chart.Line
            fillPositionedParent
            data={powerData}
            rangeX={[0, powerData.length - 1]}
            rangeY={[0, 1500]}
            strokeColor="rgba(255, 215, 0, 1)"
            fillColor="rgba(255, 215, 0, 0.1)"
          />
          <Chart.Line
            fillPositionedParent
            data={temperatureData}
            rangeX={[0, temperatureData.length - 1]}
            rangeY={[0, 110000000]}
            strokeColor="rgba(255, 0, 0, 1)"
            fillColor="rgba(255, 0, 0, 0.1)"
          />
          <Chart.Line
            fillPositionedParent
            data={vesseltemperatureData}
            rangeX={[0, vesseltemperatureData.length - 1]}
            rangeY={[0, 11000]}
            strokeColor="rgba(255, 100, 100, 1)"
            fillColor="rgba(255, 100, 100, 0.1)"
          />
          <Chart.Line
            fillPositionedParent
            data={vesselcoolingData}
            rangeX={[0, vesselcoolingData.length - 1]}
            rangeY={[0, 11000]}
            strokeColor="rgba(0, 0, 255, 1)"
            fillColor="rgba(0, 0, 255, 0.1)"
          />
          <Chart.Line
            fillPositionedParent
            data={temdiffData}
            rangeX={[0, temdiffData.length - 1]}
            rangeY={[-110000000, 110000000]}
            strokeColor="rgba(100, 0, 100, 1)"
            fillColor="rgba(100, 0, 100, 0.1)"
          />
          <Chart.Line
            fillPositionedParent
            data={shieldData}
            rangeX={[0, shieldData.length - 1]}
            rangeY={[0, data.max_shields]}
            strokeColor="rgba(50, 100, 255, 1)"
            fillColor="rgba(50, 100, 255, 0.1)"
          />
        </Section>
      </Window.Content>
    </Window>
  );
};
