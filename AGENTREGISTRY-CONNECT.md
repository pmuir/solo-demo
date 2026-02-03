1. Scaffold a new agent

```bash
arctl agent init adk python --model-name gemini-2.5-flash diceagent
```

2. Explore the agent - look at `agent.py`

3. Build and run the agent locally. Example prompts are: "What can you do" and "Roll a 6 sided die". Ctrl-c to exit

```bash
arctl agent build diceagent && arctl agent run diceagent/
```

4. Scaffold a new MCP server - look at `echo.py`

```bash
arctl mcp init python my-mcp-server --author pmuir --email pete.muir@solo.io
```

5. Explore the MCP server

6. Build and publish the new MCP server - this will publish the mcp server to our registry including: a reference to the source on github, and docker images

```bash
arctl mcp publish my-mcp-server --docker-url docker.io/pmuir --github https://github.com/pmuir/my-mcp-server --push --version 0.1.4
```

7. Add the new MCP server to the agent blueprint (all the dependencies needed for the agent so the registry can make sure to deploy everything it needs)

```bash
arctl agent add-mcp echo-mcp-server --registry-url http://34.48.164.57:8080/ --registry-server-name pmuir/my-mcp-server --registry-server-version 0.1.4 --env MCP_TRANSPORT_MODE=http --env HOST=0.0.0.0 --project-dir diceagent
```

8. Run the agent locally. Example prompts are: "What can you do" and "Roll a 6 sided die and echo back the result". Ctrl-c to exit

```bash
arctl agent run diceagent/
```

10. Build & push a doceker image for the agent

```bash
arctl agent build diceagent --image docker.io/pmuir/demoagent:1 --push
```

11. Push the agent source to git

```bash
cd diceagent
git remote add -f origin git@github.com:pmuir/diceagent.git
git add *
git commit -m "initial commit"
git push -f origin HEAD
cd ..

```

12. Publish the agent to the registry

```bash
arctl agent publish diceagent --github https://github.com/pmuir/diceagent --version latest
```

13. In the UI show how you would deploy to Vertex. Then explain we have some pre-deployed agents as this take a long time:

```bash
GOOGLE_API_KEY=AIzaSyC2pWdNyIAaVLoJLpAvlKwkMU4_9uwOTQc
OTEL_EXPORTER_OTLP_TRACES_ENDPOINT=http://telemetry.agentregistry.a.solo-agentic-demo.com/v1/traces
```

14. In the UI, show the AWS agent - chat to it, show traces

15. Show the vertex agent - chat to it in the vertex UI

16. Show the kubernetes agent
