import React, { useEffect, useState } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import CoreografiaCard from '../components/CoreografiaCard';
import CoreografiaTop from '../components/CoreografiaTop';
import './CoreografiasBody.css';
import '../CoreografiasBody.css';
import CalendarIcon from '../assets/icons/calendar_fill.svg';
import LocationIcon from '../assets/icons/location_on.svg';
import CameraIcon from '../assets/icons/Camera.svg';

const BACKEND_URL = 'https://backend.rfsolutionbr.com.br';

function isDiaFolder(nome) {
  // Regex para detectar formato 'dd-mm DiaSemana' ou 'dd-mm Dia'
  return /\d{2}-\d{2} [A-Za-zÀ-ú]+/.test(nome);
}

function CoreografiasPage() {
  const { eventoId, diaId } = useParams();
  const [dias, setDias] = useState([]); // lista de dias se houver
  const [diaSelecionado, setDiaSelecionado] = useState('');
  const [coreografias, setCoreografias] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [evento, setEvento] = useState(null);
  const navigate = useNavigate();

  // Carregar pastas de dias ou coreografias do evento
  useEffect(() => {
    setLoading(true);
    fetch(`${BACKEND_URL}/api/eventos/${encodeURIComponent(eventoId)}/coreografias`)
      .then(res => res.json())
      .then(data => {
        if (data.coreografias && data.coreografias.length > 0 && isDiaFolder(data.coreografias[0].nome)) {
          // Evento com múltiplos dias
          setDias(data.coreografias);
          setDiaSelecionado(data.coreografias[0].nome); // Seleciona o primeiro dia automaticamente
          setCoreografias([]);
        } else {
          // Evento com coreografias diretamente
          setDias([]);
          setCoreografias((data.coreografias || []).slice().sort((a, b) => {
            const numA = parseInt((a.nome.match(/\d+/) || [null])[0], 10);
            const numB = parseInt((b.nome.match(/\d+/) || [null])[0], 10);
            if (!isNaN(numA) && !isNaN(numB)) {
              return numA - numB;
            } else if (!isNaN(numA)) {
              return -1;
            } else if (!isNaN(numB)) {
              return 1;
            } else {
              return a.nome.localeCompare(b.nome, 'pt', { sensitivity: 'base' });
            }
          }));
        }
        setLoading(false);
      })
      .catch(err => {
        setError('Erro ao carregar coreografias');
        setLoading(false);
      });
  }, [eventoId]);

  // Se for múltiplos dias, buscar coreografias do dia selecionado
  useEffect(() => {
    if (dias.length > 0 && diaSelecionado) {
      setLoading(true);
      fetch(`${BACKEND_URL}/api/eventos/${encodeURIComponent(eventoId)}/${encodeURIComponent(diaSelecionado)}/coreografias`)
        .then(res => res.json())
        .then(data => {
          setCoreografias((data.coreografias || []).slice().sort((a, b) => {
            const numA = parseInt((a.nome.match(/\d+/) || [null])[0], 10);
            const numB = parseInt((b.nome.match(/\d+/) || [null])[0], 10);
            if (!isNaN(numA) && !isNaN(numB)) {
              return numA - numB;
            } else if (!isNaN(numA)) {
              return -1;
            } else if (!isNaN(numB)) {
              return 1;
            } else {
              return a.nome.localeCompare(b.nome, 'pt', { sensitivity: 'base' });
            }
          }));
          setLoading(false);
        })
        .catch(err => {
          setError('Erro ao carregar coreografias do dia');
          setLoading(false);
        });
    }
  }, [dias, diaSelecionado, eventoId]);

  useEffect(() => {
    fetch(`${BACKEND_URL}/api/admin/eventos`)
      .then(res => res.json())
      .then(data => {
        if (!Array.isArray(data)) {
          setEvento(null);
          return;
        }
        const ev = data.find(e => e.nome === eventoId) || data.find(e => e.nome.toLowerCase() === eventoId.toLowerCase());
        if (ev) {
          setEvento({ ...ev, data: ev.data ? new Date(ev.data).toLocaleDateString('pt-BR') : null });
        } else {
          setEvento(null);
        }
      })
      .catch(() => setEvento(null));
  }, [eventoId]);

  const totalFotos = coreografias.reduce((acc, c) => acc + (c.quantidade || 0), 0);

  if (loading) return <div>Carregando coreografias...</div>;
  if (error) return <div>{error}</div>;

  return (
    <>
      <CoreografiaTop nome={eventoId.replace(/%20/g, ' ')} />
      <div className="evento-info-bar">
        {evento && evento.data && (
          <span className="evento-info-item">
            <img src={CalendarIcon} alt="Data" style={{width:16,marginRight:6,verticalAlign:'middle'}} />
            {evento.data}
          </span>
        )}
        {evento && evento.local && (
          <span className="evento-info-item">
            <img src={LocationIcon} alt="Local" style={{width:16,marginRight:6,verticalAlign:'middle'}} />
            {evento.local}
          </span>
        )}
        <span className="evento-info-item">
          <img src={CameraIcon} alt="Fotos" style={{width:16,marginRight:6,verticalAlign:'middle'}} />
          {totalFotos} fotos
        </span>
      </div>
      {dias.length > 0 && (
        <div style={{ display: 'flex', gap: 12, margin: '16px 0', overflowX: 'auto' }}>
          {dias.map((dia) => (
            <button
              key={dia.nome}
              className={diaSelecionado === dia.nome ? 'dia-btn dia-btn-selected' : 'dia-btn'}
              onClick={() => setDiaSelecionado(dia.nome)}
              style={{
                padding: '10px 18px',
                borderRadius: 10,
                border: 'none',
                background: diaSelecionado === dia.nome ? '#ffe001' : '#222',
                color: diaSelecionado === dia.nome ? '#222' : '#ffe001',
                fontWeight: 600,
                fontSize: 15,
                cursor: 'pointer',
                boxShadow: diaSelecionado === dia.nome ? '0 2px 8px #ffe00144' : 'none',
                transition: 'all 0.2s',
                minWidth: 120,
              }}
            >
              {dia.nome}
            </button>
          ))}
        </div>
      )}
      <div className="body">
        {coreografias.map((coreografia, idx) => (
          <div key={coreografia.nome} onClick={() => navigate(dias.length > 0
            ? `/eventos/${eventoId}/${encodeURIComponent(diaSelecionado)}/${encodeURIComponent(coreografia.nome)}/fotos`
            : `/eventos/${eventoId}/${encodeURIComponent(coreografia.nome)}/fotos`
          )} style={{cursor: 'pointer'}}>
            <CoreografiaCard
              nome={coreografia.nome}
              capa={coreografia.capa}
              quantidade={coreografia.quantidade}
              className={`coreografia-instance coreografia-${idx+1}`}
            />
          </div>
        ))}
      </div>
    </>
  );
}

export default CoreografiasPage; 