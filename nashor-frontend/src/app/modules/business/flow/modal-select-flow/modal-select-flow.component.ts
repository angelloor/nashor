import { Component, Inject, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { MAT_DIALOG_DATA } from '@angular/material/dialog';
import { Store } from '@ngrx/store';
import { AppInitialData } from 'app/core/app/app.type';
import { Subject, takeUntil } from 'rxjs';
import { FlowService } from '../flow.service';
import { Flow } from '../flow.types';
import { ModalSelectFlowService } from './modal-select-flow.service';

@Component({
  selector: 'app-modal-select-flow',
  templateUrl: './modal-select-flow.component.html',
})
export class ModalSelectFlowComponent implements OnInit {
  id_flow: string = '';
  id_company: string = '';

  private _unsubscribeAll: Subject<any> = new Subject<any>();
  private data!: AppInitialData;

  listFlow: Flow[] = [];
  selectFlowForm!: FormGroup;

  constructor(
    private _store: Store<{ global: AppInitialData }>,
    @Inject(MAT_DIALOG_DATA) public _data: any,
    private _formBuilder: FormBuilder,
    private _flowService: FlowService,
    private _modalSelectFlowService: ModalSelectFlowService
  ) {}

  ngOnInit(): void {
    /**
     * Subscribe to user changes of state
     */
    this._store.pipe(takeUntil(this._unsubscribeAll)).subscribe((state) => {
      this.data = state.global;
      this.id_company = this.data.user.company.id_company;
    });
    /**
     * get the list of flow
     */
    this._flowService
      .byCompanyQueryRead(this.id_company, '*')
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((_flows: Flow[]) => {
        this.listFlow = _flows;
      });
    /**
     * form
     */
    this.selectFlowForm = this._formBuilder.group({
      id_flow: ['', [Validators.required]],
    });
  }
  /**
   * patchForm
   */
  patchForm(): void {
    this.selectFlowForm.patchValue({
      id_flow: this.selectFlowForm.getRawValue().id_flow,
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
  }
  /**
   * changeSelect
   */
  changeSelect(): void {
    this.id_flow = this.selectFlowForm.getRawValue().id_flow;
    this.patchForm();
  }
  /**
   * closeModalSelectFlow
   */
  closeModalSelectFlow(): void {
    this._modalSelectFlowService.closeModalSelectFlow();
  }
}
