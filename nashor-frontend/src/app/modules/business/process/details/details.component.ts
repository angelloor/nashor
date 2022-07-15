import { angelAnimations } from '@angel/animations';
import { AngelAlertType } from '@angel/components/alert';
import {
  ActionAngelConfirmation,
  AngelConfirmationService,
} from '@angel/services/confirmation';
import { OverlayRef } from '@angular/cdk/overlay';
import { DOCUMENT } from '@angular/common';
import { ChangeDetectorRef, Component, Inject, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { MatDrawerToggleResult } from '@angular/material/sidenav';
import { ActivatedRoute, Router } from '@angular/router';
import { Store } from '@ngrx/store';
import { AppInitialData, MessageAPI } from 'app/core/app/app.type';
import { LayoutService } from 'app/layout/layout.service';
import { NotificationService } from 'app/shared/notification/notification.service';
import { filter, fromEvent, merge, Subject, takeUntil } from 'rxjs';
import { flowVersion } from '../../flow/flow-version/flow-version.data';
import { FlowVersionService } from '../../flow/flow-version/flow-version.service';
import { FlowVersion } from '../../flow/flow-version/flow-version.types';
import { official } from '../../official/official.data';
import { OfficialService } from '../../official/official.service';
import { Official } from '../../official/official.types';
import { processType } from '../../process-type/process-type.data';
import { ProcessTypeService } from '../../process-type/process-type.service';
import { ProcessType } from '../../process-type/process-type.types';
import { ProcessListComponent } from '../list/list.component';
import { ProcessService } from '../process.service';
import { Process } from '../process.types';

@Component({
  selector: 'process-details',
  templateUrl: './details.component.html',
  animations: angelAnimations,
})
export class ProcessDetailsComponent implements OnInit {
  id_company: string = '';

  listProcessType: ProcessType[] = [];
  selectedProcessType: ProcessType = processType;

  listOfficial: Official[] = [];
  selectedOfficial: Official = official;

  listFlowVersion: FlowVersion[] = [];
  selectedFlowVersion: FlowVersion = flowVersion;

  nameEntity: string = 'Procesos';
  private data!: AppInitialData;

  editMode: boolean = false;
  /**
   * Alert
   */
  alert: { type: AngelAlertType; message: string } = {
    type: 'error',
    message: '',
  };
  showAlert: boolean = false;
  /**
   * Alert
   */
  process!: Process;
  processForm!: FormGroup;
  private processs!: Process[];

  private _tagsPanelOverlayRef!: OverlayRef;
  private _unsubscribeAll: Subject<any> = new Subject<any>();
  /**
   * isOpenModal
   */
  isOpenModal: boolean = false;
  /**
   * isOpenModal
   */
  /**
   * Constructor
   */
  constructor(
    private _store: Store<{ global: AppInitialData }>,
    private _changeDetectorRef: ChangeDetectorRef,
    private _processListComponent: ProcessListComponent,
    private _processService: ProcessService,
    @Inject(DOCUMENT) private _document: any,
    private _formBuilder: FormBuilder,
    private _activatedRoute: ActivatedRoute,
    private _router: Router,
    private _notificationService: NotificationService,
    private _angelConfirmationService: AngelConfirmationService,
    private _layoutService: LayoutService,
    private _processTypeService: ProcessTypeService,
    private _officialService: OfficialService,
    private _flowVersionService: FlowVersionService
  ) {}

  /** ----------------------------------------------------------------------------------------------------- */
  /** @ Lifecycle hooks
	  /** ----------------------------------------------------------------------------------------------------- */

  /**
   * On init
   */
  ngOnInit(): void {
    /**
     * isOpenModal
     */
    this._layoutService.isOpenModal$
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((_isOpenModal: boolean) => {
        this.isOpenModal = _isOpenModal;
      });
    /**
     * isOpenModal
     */
    /**
     * Subscribe to user changes of state
     */
    this._store.pipe(takeUntil(this._unsubscribeAll)).subscribe((state) => {
      this.data = state.global;
      this.id_company = this.data.user.company.id_company;
    });
    /**
     * Open the drawer
     */
    this._processListComponent.matDrawer.open();
    /**
     * Create the process form
     */
    this.processForm = this._formBuilder.group({
      id_process: [''],
      id_process_type: ['', [Validators.required]],
      id_official: ['', [Validators.required]],
      id_flow_version: ['', [Validators.required]],
      number_process: ['', [Validators.required, Validators.maxLength(150)]],
      date_process: ['', [Validators.required]],
      generated_task: ['', [Validators.required]],
      finalized_process: ['', [Validators.required]],
    });
    /**
     * Get the processs
     */
    this._processService.processs$
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((processs: Process[]) => {
        this.processs = processs;
        /**
         * Mark for check
         */
        this._changeDetectorRef.markForCheck();
      });
    /**
     * Get the process
     */
    this._processService.process$
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((process: Process) => {
        /**
         * Open the drawer in case it is closed
         */
        this._processListComponent.matDrawer.open();
        /**
         * Get the process
         */
        this.process = process;

        // ProcessType
        this._processTypeService
          .byCompanyQueryRead(this.id_company, '*')
          .pipe(takeUntil(this._unsubscribeAll))
          .subscribe((process_types: ProcessType[]) => {
            this.listProcessType = process_types;

            this.selectedProcessType = this.listProcessType.find(
              (item) =>
                item.id_process_type ==
                this.process.process_type.id_process_type.toString()
            )!;
          });

        // Official
        this._officialService
          .byCompanyQueryRead(this.id_company, '*')
          .pipe(takeUntil(this._unsubscribeAll))
          .subscribe((officials: Official[]) => {
            this.listOfficial = officials;

            this.selectedOfficial = this.listOfficial.find(
              (item) =>
                item.id_official == this.process.official.id_official.toString()
            )!;
          });

        // FlowVersion
        this._flowVersionService
          .byFlowRead(this.process.flow_version.flow.id_flow)
          .pipe(takeUntil(this._unsubscribeAll))
          .subscribe((flow_versions: FlowVersion[]) => {
            this.listFlowVersion = flow_versions;

            this.selectedFlowVersion = this.listFlowVersion.find(
              (item) =>
                item.id_flow_version ==
                this.process.flow_version.id_flow_version.toString()
            )!;
          });

        /**
         * Patch values to the form
         */
        this.patchForm();
        /**
         * Toggle the edit mode off
         */
        this.toggleEditMode(false);
        /**
         * Mark for check
         */
        this._changeDetectorRef.markForCheck();
      });
    /**
     * Shortcuts
     */
    merge(
      fromEvent(this._document, 'keydown').pipe(
        takeUntil(this._unsubscribeAll),
        filter<KeyboardEvent | any>((e) => e.key === 'Escape')
      )
    )
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((keyUpOrKeyDown) => {
        /**
         * Shortcut Escape
         */
        if (!this.isOpenModal && keyUpOrKeyDown.key == 'Escape') {
          /**
           * Navigate parentUrl
           */
          const parentUrl = this._router.url.split('/').slice(0, -1).join('/');
          this._router.navigate([parentUrl]);
          /**
           * Close Drawer
           */
          this.closeDrawer();
        }
      });
    /**
     * Shortcuts
     */
  }
  /**
   * Pacth the form with the information of the database
   */
  patchForm(): void {
    this.processForm.patchValue({
      ...this.process,
      id_process_type: this.process.process_type.id_process_type,
      id_official: this.process.official.id_official,
      id_flow_version: this.process.flow_version.id_flow_version,
    });
  }
  /**
   * On destroy
   */
  ngOnDestroy(): void {
    /**
     * Unsubscribe from all subscriptions
     */
    this._unsubscribeAll.next(0);
    this._unsubscribeAll.complete();
    /**
     * Dispose the overlays if they are still on the DOM
     */
    if (this._tagsPanelOverlayRef) {
      this._tagsPanelOverlayRef.dispose();
    }
  }

  /** ----------------------------------------------------------------------------------------------------- */
  /** @ Public methods
	  /** ----------------------------------------------------------------------------------------------------- */

  /**
   * Close the drawer
   */
  closeDrawer(): Promise<MatDrawerToggleResult> {
    return this._processListComponent.matDrawer.close();
  }
  /**
   * Toggle edit mode
   * @param editMode
   */
  toggleEditMode(editMode: boolean | null = null): void {
    this.patchForm();

    if (editMode === null) {
      this.editMode = !this.editMode;
    } else {
      this.editMode = editMode;
    }
    /**
     * Mark for check
     */
    this._changeDetectorRef.markForCheck();
  }

  /**
   * Update the process
   */
  updateProcess(): void {
    /**
     * Get the process
     */
    const id_user_ = this.data.user.id_user;
    let process = this.processForm.getRawValue();
    /**
     * Delete whitespace (trim() the atributes type string)
     */
    process = {
      ...process,
      id_user_: parseInt(id_user_),
      id_process: parseInt(process.id_process),
      process_type: {
        id_process_type: parseInt(process.id_process_type),
      },
      official: {
        id_official: parseInt(process.id_official),
      },
      flow_version: {
        id_flow_version: parseInt(process.id_flow_version),
      },
    };
    /**
     * Update
     */
    this._processService
      .update(process)
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe({
        next: (_process: Process) => {
          if (_process) {
            this._notificationService.success(
              'Procesos actualizada correctamente'
            );
            /**
             * Toggle the edit mode off
             */
            this.toggleEditMode(false);
          } else {
            this._notificationService.error(
              '¡Error interno!, consulte al administrador.'
            );
          }
        },
        error: (error: { error: MessageAPI }) => {
          this._notificationService.error(
            !error.error
              ? '¡Error interno!, consulte al administrador.'
              : !error.error.description
              ? '¡Error interno!, consulte al administrador.'
              : error.error.description
          );
        },
      });
  }
  /**
   * Delete the process
   */
  deleteProcess(): void {
    this._angelConfirmationService
      .open({
        title: 'Eliminar procesos',
        message:
          '¿Estás seguro de que deseas eliminar esta procesos? ¡Esta acción no se puede deshacer!',
      })
      .afterClosed()
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((confirm: ActionAngelConfirmation) => {
        if (confirm === 'confirmed') {
          /**
           * Get the current process's id
           */
          const id_user_ = this.data.user.id_user;
          const id_process = this.process.id_process;
          /**
           * Get the next/previous process's id
           */
          const currentIndex = this.processs.findIndex(
            (item) => item.id_process === id_process
          );

          const nextIndex =
            currentIndex + (currentIndex === this.processs.length - 1 ? -1 : 1);
          const nextId =
            this.processs.length === 1 &&
            this.processs[0].id_process === id_process
              ? null
              : this.processs[nextIndex].id_process;
          /**
           * Delete
           */
          this._processService
            .delete(id_user_, id_process)
            .pipe(takeUntil(this._unsubscribeAll))
            .subscribe({
              next: (response: boolean) => {
                if (response) {
                  /**
                   * Return if the process wasn't deleted...
                   */
                  this._notificationService.success(
                    'Procesos eliminada correctamente'
                  );
                  /**
                   * Get the current activated route
                   */
                  let route = this._activatedRoute;
                  while (route.firstChild) {
                    route = route.firstChild;
                  }
                  /**
                   * Navigate to the next process if available
                   */
                  if (nextId) {
                    this._router.navigate(['../', nextId], {
                      relativeTo: route,
                    });
                  } else {
                    /**
                     * Otherwise, navigate to the parent
                     */
                    this._router.navigate(['../'], { relativeTo: route });
                  }
                  /**
                   * Toggle the edit mode off
                   */
                  this.toggleEditMode(false);
                } else {
                  this._notificationService.error(
                    '¡Error interno!, consulte al administrador.'
                  );
                }
              },
              error: (error: { error: MessageAPI }) => {
                this._notificationService.error(
                  !error.error
                    ? '¡Error interno!, consulte al administrador.'
                    : !error.error.description
                    ? '¡Error interno!, consulte al administrador.'
                    : error.error.description
                );
              },
            });
          /**
           * Mark for check
           */
          this._changeDetectorRef.markForCheck();
        }
        this._layoutService.setOpenModal(false);
      });
  }
}
